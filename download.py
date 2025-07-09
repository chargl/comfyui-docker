"""
Go download the "models" folder structure directly from the comfyui source
"""
import requests
from pathlib import Path


def recursive_download(url):
	"""

	:param url:
	:return:
	"""
	print(f'Recursive download: {url}')
	query = requests.get(url)
	if query.status_code == 200:
		result = query.json()

		for item in result:
			path = Path(item['path'])

			if item['type'] == 'file':
				download_url = item['download_url']
				print(f'File download: {download_url}')
				dl = requests.get(download_url)
				if dl.status_code == 200:
					with open(path, 'wb') as file:
						file.write(dl.content)
				else:
					print(f'Request "{download_url}" failed with status code {query.status_code}')
					print(query.json())

			else:
				path.mkdir(parents=True, exist_ok=True)
				recursive_download(item['_links']['self'])


	else:
		print(f'Request "{url}" failed with status code {query.status_code}')
		print(query.json())

recursive_download('https://api.github.com/repos/comfyanonymous/ComfyUI/contents/models')
