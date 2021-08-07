# server: main.cpp ./threadpool/threadpool.h ./http/http_conn.cpp ./http/http_conn.h ./lock/locker.h ./log/log.cpp ./log/log.h ./log/block_queue.h ./CGImysql/sql_connection_pool.cpp ./CGImysql/sql_connection_pool.h
# 	g++ -o server main.cpp ./threadpool/threadpool.h ./http/http_conn.cpp ./http/http_conn.h ./lock/locker.h ./log/log.cpp ./log/log.h ./CGImysql/sql_connection_pool.cpp ./CGImysql/sql_connection_pool.h -lpthread -lmysqlclient

# clean:
# 	rm  -r server


# Version 2
# TGT = server
# SRCS = main.cpp ./threadpool/threadpool.h ./http/http_conn.cpp ./http/http_conn.h ./lock/locker.h ./log/log.cpp ./log/log.h ./log/block_queue.h ./CGImysql/sql_connection_pool.cpp ./CGImysql/sql_connection_pool.h
# CC = g++
# $(TGT): $(SRCS)
# 	$(CC) -o $@ $^ -lpthread -lmysqlclient
# .PHONY: clean
# clean:
# 	-rm  -r server

# Version 3
TGT = server
SRCS = main.cpp http_conn.cpp log.cpp sql_connection_pool.cpp
CC = g++
PROJECT_DIR = $(shell pwd)
SRC_DIR = $(PROJECT_DIR)/threadpool $(PROJECT_DIR)/http $(PROJECT_DIR)/lock $(PROJECT_DIR)/log $(PROJECT_DIR)/CGImysql 
CFLAGS = $(SRC_DIR:%=-I%) -lpthread -lmysqlclient
vpath %.cpp $(SRC_DIR)

# TGT 依赖于 .o 文件， 同时 默认规则里面自动创建.cpp到.o的依赖
$(TGT): $(SRCS:.cpp=.o)
	$(CC) -o $@ $^ $(CFLAGS)
# make clean

# 为了保证头文件可以被搜到，创建.d文件 并导入  .d文件中包含了每个.cpp依赖的头文件
%.d: %.cpp
	$(CC) -MM $< > $@

#  将.d文件里面的内容展开在这里  这里是头文件到.o文件的依赖
sinclude $(SRCS:.cpp=.d)

# 总结 ： .h变化 会引起 对应的.o的变化(由sinclude引入)， .cpp的变化 也会引起.o的变化(由TGT那条规则创建的默认依赖)  .o的变化最终会引起TGT的变化

# 伪目标,就算真的存在这个clean这个文件也不影响
.PHONY: clean
clean:
	-rm  $(SRCS:.cpp=.d) $(SRCS:.cpp=.o)

.PHONY: remove
remove:
	-rm  -r $(TGT) $(SRCS:.cpp=.d) $(SRCS:.cpp=.o)