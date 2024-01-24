
if [ "$COPY_KEY" = "true" ]; then
	temp_file=$(mktemp)
	cp $KEY $temp_file
	trap '{ rm -f -- "$temp_file"; }' EXIT
	chmod 600 $temp_file
	KEY=$temp_file
fi


if [ "$REMOTE" != "true" ]; then
	ssh \
		-vv \
		-o StrictHostKeyChecking=no \
		-Nn $TUNNEL_HOST \
		-p $TUNNEL_PORT \
		-L *:$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT \
		-i $KEY \
		-l $USER
else
	ssh \
		-vv \
		-o StrictHostKeyChecking=no \
		-Nn $TUNNEL_HOST \
		-p $TUNNEL_PORT \
		-R 0.0.0.0:$REMOTE_PORT:$CONTAINER_HOST:$CONTAINER_PORT \
		-i $KEY \
		-l $USER
fi
