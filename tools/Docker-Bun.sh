docker run -it --rm --name bun \
	-v ${PWD}:/home/bun/app \
	-v Bun:/root \
	oven/bun:latest bash
