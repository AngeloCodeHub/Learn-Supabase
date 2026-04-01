docker run -it --rm -w /home \
  --entrypoint /bin/sh \
  -v ${PWD}:/home \
  -v opencode:/root/.local/share/opencode \
	ghcr.io/anomalyco/opencode
