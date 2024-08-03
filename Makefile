build:
	docker buildx build --platform linux/amd64,linux/arm64 -t nherbaut/motionplus:latest --load .
push:
	docker buildx build --platform linux/amd64,linux/arm64 -t nherbaut/motionplus:latest --push .
run:
	docker run --rm --name motionplus -p 8080:8080 -v ./conf/output:/var/motionsplus/:rw -v ./conf/etc/motionplus/:/etc/motionplus/  nherbaut/motionplus 
