exeComm="specify init --here --ignore-agent-tools"

docker run -it --rm -w /home \
	-v uv:/root \
	-v ${PWD}:/home \
	ghcr.io/astral-sh/uv:debian /bin/bash
	# ghcr.io/astral-sh/uv:debian /bin/bash -i -c "$exeComm"
