# creates virtual environment for testing

venv:
	bash -c '[ -d venv ] || python3 -m venv venv'
	venv/bin/pip3 install -r requirements.txt
	venv/bin/pip3 install jupyterlab