docker run -it --rm --name opencode \
	-v ${PWD}:/home/bun/app \
	-v opencode:/root \
	oven/bun:latest bash
