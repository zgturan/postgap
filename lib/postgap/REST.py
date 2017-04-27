#! /usr/bin/env python

"""

Copyright [1999-2016] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License")
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

"""

"""

	Please email comments or questions to the public Ensembl
	developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

	Questions may also be sent to the Ensembl help desk at
	<http://www.ensembl.org/Help/Contact>.

"""
import sys
import requests
import json
import time

from postgap.Globals import *

def get(server, ext, data=None):
	"""
		Args:
		* String (server name)
		* String (extension string)
		Return type: JSON object

	"""
	for retries in range(3):
		if DEBUG:
			sys.stderr.write("REST JSON Query: %s%s\n" % (server, ext))
			start_time = time.time()

		try:
			if data is None:
				headers = { "Content-Type" : "application/json" }
				r = requests.get(str(server)+str(ext), headers = headers, timeout=200)
			else:
				headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
				r = requests.post(str(server)+str(ext), headers = headers, data = json.dumps(data), timeout=200)
                except requests.exceptions.ReadTimeout:
			continue
		except requests.exceptions.ConnectionError:
			# A timeout can creep up as a connection error, so catching this as well.
			# requests.exceptions.ConnectionError: HTTPConnectionPool(host='grch37.rest.ensembl.org', port=80): Read timed out.
			continue


		if not r.ok:
			sys.stderr.write("Failed to get proper response to query %s%s\n" % (server, ext) )
			sys.stderr.write("With headers:\n" + repr(headers) + "\n")
			if data is not None:
				sys.stderr.write("With data:\n" + repr(data) + "\n")
			sys.stderr.write("Error code: %s\n" % r.status_code)

			if retries == 2:
				r.raise_for_status()

			if 'Retry-After' in r.headers:
				time.sleep(int(r.headers['Retry-After']))

			elif r.status_code == 403:
				time.sleep(600) # Sleep 10 minutes while server calms down
			elif r.status_code == 104 or r.status_code == 504:
				time.sleep(60) # Sleep 1 minute while server cools down
			else:
				r.raise_for_status()
			continue

		if DEBUG:
			sys.stderr.write("Time: %f\n" % (time.time() - start_time))

		try:
			return r.json()
		except:
			sys.stderr.write("Failed to get proper response to query %s%s\n" % (server, ext) )
			raise

	# Failed too many times
	assert False

