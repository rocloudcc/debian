#!/bin/bash

# 使用ipinfo.io获取国家
country=$(curl -s https://ipinfo.io/country)

# 定义一个关联数组来存储国家与DNS服务器的映射
declare -A country_dns
country_dns["PH"]="121.58.203.4 8.8.8.8"
country_dns["VN"]="183.91.184.14 8.8.8.8"
country_dns["MY"]="49.236.193.35 8.8.8.8"
country_dns["TH"]="61.19.42.5 8.8.8.8"
country_dns["ID"]="202.146.128.3 202.146.128.7 202.146.131.12"
country_dns["TW"]="168.95.1.1 8.8.8.8"
country_dns["HK"]="1.1.1.1 8.8.8.8"
country_dns["JP"]="133.242.1.1 133.242.1.2"
country_dns["US"]="1.1.1.1 8.8.8.8"
country_dns["DE"]="217.172.224.47 194.150.168.168"
country_dns["AE"]="217.172.224.47 194.150.168.168"
# 添加其他国家的DNS服务器

# 检查是否有国家的DNS配置
if [ -n "${country_dns[$country]}" ]; then
    custom_dns="${country_dns[$country]}"
else
    custom_dns="8.8.8.8 8.8.4.4"  # 默认的DNS服务器
fi

# 修改DNS配置文件
conf_path="/etc/network/interfaces.d/50-cloud-init"  # 请根据实际情况更改路径

# 备份原始配置文件
cp "$conf_path" "$conf_path.bak"

# 修改DNS配置
sed -i "s/dns-nameservers .*/dns-nameservers $custom_dns;/" "$conf_path"

# 重启网络服务以应用更改
service networking restart

echo "DNS配置已更新为: $custom_dns"
