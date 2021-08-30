docker build -t proxy-to-proxy .
proxy1=$(cat proxies.txt  | awk 'BEGIN{srand();}{print rand()"\t"$0}' | sort -k1 -n | cut -f2- | head -1)
docker run -itd --name proxy-to-proxy -p 3128:3128 --env proxy="$proxy1" -v $(pwd)/3proxy.cfg:/etc/3proxy/3proxy.cfg:rw proxy-to-proxy:latest
