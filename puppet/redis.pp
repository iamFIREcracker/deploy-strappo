include redis

redis::conf {'redis-conf':
  address => $redisaddress,
  port => $redisport,
}
