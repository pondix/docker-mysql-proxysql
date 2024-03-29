version: "2.0"
services:
  mysql1:
    image: mysql:8.0.30
    ports: 
      - "13306:3306"
    volumes:
      - ./conf/mysql/mysql1:/etc/mysql/conf.d
    networks:
      - backend
    environment:
      - MYSQL_ROOT_PASSWORD=root
  mysql2:
    image: mysql:8.0.30
    ports: 
      - "13307:3306"
    volumes:
      - ./conf/mysql/mysql2:/etc/mysql/conf.d
    networks:
      - backend
    depends_on:
      - mysql1
    environment:
      - MYSQL_ROOT_PASSWORD=root
  mysql3:
    image: mysql:8.0.30
    ports: 
      - "13308:3306"
    volumes:
      - ./conf/mysql/mysql3:/etc/mysql/conf.d
    networks:
      - backend
    depends_on:
      - mysql1
    environment:
      - MYSQL_ROOT_PASSWORD=root
  proxysql:
    image: proxysql/proxysql:latest
    ports:
      - "16033:6033"
      - "16032:6032"
    volumes:
      - ./conf/proxysql/proxysql.cnf:/etc/proxysql.cnf
    depends_on:
      - mysql1
      - mysql2
      - mysql3
    networks:
      - frontend
      - backend
  orc1:
    build: ./conf/orchestrator/
    ports:
      - "23101:3000"
    volumes:
      - ./conf/orchestrator/orc1/orchestrator.conf.json:/etc/orchestrator.conf.json
      - ./conf/orchestrator/remove-proxysql-host.bash:/root/remove-proxysql-host.bash
    depends_on:
      - mysql1
      - mysql2
      - mysql3
      - proxysql
    networks:
      - backend
  orc2:
    build: ./conf/orchestrator/
    ports:
      - "23102:3000"
    volumes:
      - ./conf/orchestrator/orc2/orchestrator.conf.json:/etc/orchestrator.conf.json
      - ./conf/orchestrator/remove-proxysql-host.bash:/root/remove-proxysql-host.bash
    depends_on:
      - mysql1
      - mysql2
      - mysql3
      - proxysql
    networks:
      - backend
  orc3:
    build: ./conf/orchestrator/
    ports:
      - "23103:3000"
    volumes:
      - ./conf/orchestrator/orc3/orchestrator.conf.json:/etc/orchestrator.conf.json
      - ./conf/orchestrator/remove-proxysql-host.bash:/root/remove-proxysql-host.bash
    depends_on:
      - mysql1
      - mysql2
      - mysql3
      - proxysql
    networks:
      - backend
networks:
  frontend:
  backend:
