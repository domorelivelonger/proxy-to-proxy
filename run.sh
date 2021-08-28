proxy=$(cat proxies.txt  | awk 'BEGIN{srand();}{print rand()"\t"$0}' | sort -k1 -n | cut -f2- | head -1)
docker build -t proxy-to-proxy --build-arg http_proxy=http://$proxy .
