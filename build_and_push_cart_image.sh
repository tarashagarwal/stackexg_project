if [[ -d "app" ]]; then
	cp -rf app temp_app &&
	docker build --tag tarashagarwal/cart_app . &&
	docker push tarashagarwal/cart_app &&
	rm -rf temp_app
fi