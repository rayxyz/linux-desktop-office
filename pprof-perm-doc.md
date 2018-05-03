#并发测试
## Siege
下载地址：http://download.joedog.org/siege/
下载完后解压：
```shell
ray@ray-pc:~/Downloads$ sudo tar -xzvf siege-latest.tar.gz
```
解压完成，进到siege源码目录，编译siege源码：
```shell
ray@ray-pc:~/Downloads$ cd siege-4.0.2
```
![](/uploads/201707/14d2fb7215a0cae5.png)

编译源码包，并将siege安装到/usr/local/bin
```shell
ray@ray-pc:~/Downloads/siege-4.0.2$ sudo ./configure
ray@ray-pc:~/Downloads/siege-4.0.2$ sudo make
ray@ray-pc:~/Downloads/siege-4.0.2$ sudo make install
```
安装完成后，就可以在/usr/local/bin中查看安装的文件:
![](/uploads/201707/14d2fbe497778832.png)
查看siege是否安装成功：
![](/uploads/201707/14d2fc2e13ed9092.png)
查看siege的默认配置信息：
```shell
ray@ray-pc:~/Downloads/siege-4.0.2$ siege -C
CURRENT  SIEGE  CONFIGURATION
Mozilla/5.0 (unknown-x86_64-linux-gnu) Siege/4.0.2
Edit the resource file to change the settings.
----------------------------------------------
version:                        4.0.2
verbose:                        true
color:                          true
quiet:                          false
debug:                          false
protocol:                       HTTP/1.1
HTML parser:                    disabled
get method:                     HEAD
connection:                     close
concurrent users:               15
time to run:                    n/a
repetitions:                    n/a
socket timeout:                 30
accept-encoding:                gzip
delay:                          1.000 sec
internet simulation:            false
benchmark mode:                 false
failures until abort:           1024
named URL:                      none
URLs file:                      /usr/local/etc/urls.txt
thread limit:                   255
logging:                        true
log file:                       /usr/local/var/log/siege.log
resource file:                  /home/ray/.siege/siege.conf
timestamped output:             false
comma separated output:         false
allow redirects:                true
allow zero byte data:           true
allow chunked encoding:         true
upload unique files:            true
```
从配置文件中可以看到，默认的线程数限制在255，可以通过修改siege.conf配置信息来修改默认配置.
```shell
$ sudo vim ~/.siege/siege.conf
```
![](/uploads/201707/14d2fc9de81c2c77.png)

并发请求url地址， 如：
```shell
ray@ray-pc:~$ siege -c 200 -i http://localhost:8110/usercenter/getUserInfo/342668
```
其中c是并发用户数，i是要请求的地址，可用siege --help命令查看详细的使用帮助.
```shell
Lifting the server siege...
Transactions:		         964 hits
Availability:		      100.00 %
Elapsed time:		       24.57 secs
Data transferred:	        0.16 MB
Response time:		        4.20 secs
Transaction rate:	       39.23 trans/sec
Throughput:		        0.01 MB/sec
Concurrency:		      164.95
Successful transactions:         964
Failed transactions:	           0
Longest transaction:	        6.12
Shortest transaction:	        0.07
```
请求完成后，可以看到总结性的信息.
## go-wrk
go-wrk是一个性能测试工具，支持https、post请求、统计等.
地址：https://github.com/adjust/go-wrk
用git将源码下载到Go的src目录
```
git clone git://github.com/adeven/go-wrk.git
cd go-wrk
go build
```
安装成功后：
![](/uploads/201707/14d2fd6c453399e1.png)
用go-wrk做测试：
```shell
ray@ray-pc:~/go_workspace/src/go-wrk$ ./go-wrk -c=10 -n=1000 -t=10 http://localhost:8110/usercenter/getUserInfoDetail/342668
```
```shell
==========================BENCHMARK==========================
URL:				http://localhost:8110/usercenter/getUserInfoDetail/342668

Used Connections:		10
Used Threads:			10
Total number of calls:		1000

===========================TIMINGS===========================
Total time passed:		25.01s
Avg time per request:		232.92ms
Requests per second:		39.98
Median time per request:	50.01ms
99th percentile time:		5001.69ms
Slowest time for request:	5021.00ms

=============================DATA=============================
Total response body sizes:		160000
Avg response body per request:		160.00ms
Transfer rate per second:		6397.43 Byte/s (0.01 MByte/s)
==========================RESPONSES==========================
20X Responses:		1000	(100.00%)
30X Responses:		0	(0.00%)
40X Responses:		0	(0.00%)
50X Responses:		0	(0.00%)
Errors:			0	(0.00%)
```
go-wrk请求完成后，会得到如上的结果。可根据需要调整相应测试请求参数。
## Locust
locust是比较强大灵活的并发测试工具，可以写python脚本来控制测试流程，测试过程可实时查看测试状态。
通过pip来安装：
```shell
pip install locustio
```
安装过程说明：http://docs.locust.io/en/latest/installation.html
使用教程：http://docs.locust.io/en/latest/quickstart.html
实例：
１．编写python脚本
```python
from locust import HttpLocust, TaskSet, task

file = open("../user_id_file.txt", "r")
uid_content = file.read()
uid_array = uid_content.split("\n")

class UserInfo(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """
        print "Starting..."

    @task(2)
    def user_info(self):
        for uid in uid_array:
            if uid is not None and uid is not "":
                print "Requesting getUserInfo, uid => " + uid
                self.client.get("/getUserInfo/%s" % uid, name="/getUserInfo/[uid]")

    @task(1)
    def user_info_detail(self):
        for uid in uid_array:
            if uid is not None and uid is not "":
                print "Requesting getUserInfoDetail, uid => " + uid
                self.client.get("/getUserInfoDetail/%s" % uid, name="/getUserInfoDetail/[uid]")

class WebsiteUser(HttpLocust):
    task_set = UserInfo
    min_wait = 5000
    max_wait = 9000
```
以上locust python代码: 从user_id_file.txt文件中读取用户id。UserInfo类中的on_start方法在locust任务执行前启动执行。user_info和user_info_detail两个方法从用户id数组中取出用户id，然后将用户id追加到http地址作为请求参数。类UserInfo作为locust的task_set。详细概念请参考Locust官网locust.io。

２． 运行locust测试服务
```shell
ray@ray-pc:~/pywork/locust$ locust -f locustfile.py --host=http://localhost:8110/usercenter
```
f是编写的python文件，host是服务的地址。启动成功后：
![](/uploads/201707/14d2ff65ae7fe6ed.png)

３．并发测试

在浏览器中访问locust的web服务：
![](/uploads/201707/14d2ff7b80587ab7.png)
设置并发访问的用户数和每秒用户增量，locust将根据每秒用户增量从０增加到并发用户数。
![](/uploads/201707/14d2ffc15d584431.png)
这里模拟并发用户数为1000，增量为20。
测试过程中可以实时查看测试状态，如下图所示：
![](/uploads/201707/14d2fff6e068d50e.png)
request: 请求数
fails: 失败的请求数
Median: 当前每秒请求数
Average: 每个请求平均用时（毫秒）
Min: 最快请求用时（毫秒）
Max: 最长请求用时（毫秒）
Content Size: 请求返回的内容大小（字节byte）
request/sec(RPS)当前每秒请求数

关闭测试后，可看到测试报告：
![](/uploads/201707/14d300c8753516ff.png)

#Profiling
##pprof
在并发测试中，我们测试出了服务接口在压力测试下的表象情况，也暴露了接口性能问题。要找到问题的原因（如接口中那段代码耗时较长等），我们将使用Golang标准包中的pprof工具来查看机器在运行中CPU处理耗时、内存中堆栈分配和垃圾回收GC。pprof还提供了代码调用追踪，可生成PDF和SVG来直观地分析程序的性能。
１．准备
在web服务中导入pprof包:
```Golang
import  _ "net/http/pprof"
```
实例：
```Golang
package main

import (
	"net/http"
	_ "net/http/pprof"
)

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello World!"))
}

func main() {
	http.HandleFunc("/", defaultHandler)
	http.ListenAndServe(":8081", nil)
}
```
如果在web应用中使用了自定义的路由（router），那么只导入pprof包，不会自动注册调试地址。有两种方法可以解决这个问题：

* 手动注册调试地址
```Golang
func init() {
	// 启用token鉴权方式
	// router.SetTokenCheck(true)
	router.Group(prefix, false, checkHeader, nil, func() {
		router.Get("/getUserInfo/:uid", "", getUserInfoHandler)
		router.Get("/getUserInfoDetail/:uid", "", getUserInfoDetailHandler)
	})
	// 手动注册.
	router.HandlerFunc(http.MethodGet, "/debug/pprof", pprof.Index)
	router.HandlerFunc(http.MethodGet, "/debug/pprof/cmdline", pprof.Cmdline)
	router.HandlerFunc(http.MethodGet, "/debug/pprof/profile", pprof.Profile)
	router.HandlerFunc(http.MethodGet, "/debug/pprof/symbol", pprof.Symbol)
	router.HandlerFunc(http.MethodGet, "/debug/pprof/trace", pprof.Trace)
}
```

* 重开一个服务监听端口
```go
func main() {
	flag.Parse()
	s, err := httpx.ListenAndServe(fmt.Sprintf(":%d", *port), router, runtime.NumCPU()*int(maxConnection))
	if err != nil {
		log.Fatal(err)
	}
	// Test only. We use another port different with the server in main go routine.
	go func() {
		log.Println(http.ListenAndServe(":8081", nil))
	}()
	// Cleanup
	signal.ListenAndServe(s)
}
```
这里我们重开了8081端口作为Profiling的监听端口。
手动注册比较麻烦，而且有的默认调试地址没法手动注册（如：http://localhost:8081/debug/pprof/heap），所以推荐使用重新开端口来监听。
注册完成后，就可以查看服务的实时调试信息：
![](/uploads/201707/14d3371e2c162c03.png)
２．用go tool pprof 分析程序运行情况
```shell
ray@ray-pc:~$ go tool pprof http://localhost:8080/debug/pprof/profile
Fetching profile from http://localhost:8080/debug/pprof/profile
Please wait... (30s)
Saved profile in /home/ray/pprof/pprof.usercenter.localhost:8080.samples.cpu.012.pb.gz
Entering interactive mode (type "help" for commands)
(pprof) top10
170ms of 310ms total (54.84%)
Showing top 10 nodes out of 156 (cum >= 10ms)
      flat  flat%   sum%        cum   cum%
      50ms 16.13% 16.13%       50ms 16.13%  runtime.memclrNoHeapPointers
      30ms  9.68% 25.81%       60ms 19.35%  runtime.mallocgc
      20ms  6.45% 32.26%       20ms  6.45%  syscall.Syscall
      10ms  3.23% 35.48%       10ms  3.23%  bytes.(*Buffer).grow
      10ms  3.23% 38.71%       10ms  3.23%  compress/flate.(*huffmanBitWriter).generateCodegen
      10ms  3.23% 41.94%       10ms  3.23%  net/http.(*connReader).backgroundRead
      10ms  3.23% 45.16%       10ms  3.23%  reflect.Value.Field
      10ms  3.23% 48.39%       10ms  3.23%  runtime.(*mcentral).cacheSpan
      10ms  3.23% 51.61%       10ms  3.23%  runtime.chanrecv
      10ms  3.23% 54.84%       10ms  3.23%  runtime.epollwait
(pprof) 
```
pprof默认进行30秒的分析，可以用-seconds参数调整分析时间，如：
```shell
ray@ray-pc:~$ go tool pprof -seconds 5 http://localhost:8080/debug/pprof/profile
```
通过pprof的web命令生成SVG:
![](/uploads/201707/14d302abbdada0af.png)

生成的SVG:
![](/uploads/201707/14d302c16228ce29.png)

用pprof的list命令查看代码耗时：
![](/uploads/201707/14d3032979f26211.png)

用list xxx(函数名)来查找特定函数的耗时：
![](/uploads/201707/14d3034aa197687b.png)

还可以用disasm 来查看底层汇编代码：
```shell
(pprof) disasm getUserBasicInfo
```
![](/uploads/201707/14d34f8ba70677a3.png)

查看内存堆栈和GC情况： http://localhost:8080/debug/pprof/heap?debug=1
```
...
# runtime.MemStats
# Alloc = 5917200
# TotalAlloc = 23788443408
# Sys = 90814776
# Lookups = 46454
# Mallocs = 67346777
# Frees = 67300560
# HeapAlloc = 5917200
# HeapSys = 79134720
# HeapIdle = 70270976
# HeapInuse = 8863744
# HeapReleased = 62799872
# HeapObjects = 46217
# Stack = 1605632 / 1605632
# MSpan = 182096 / 901120
# MCache = 4800 / 16384
# BuckHashSys = 1597961
# GCSys = 3125248
# OtherSys = 4433711
# NextGC = 10394656
# PauseNs = [...]
# NumGC = 4001
# DebugGC = false
```
查看实时goroutine信息：http://localhost:8080/debug/pprof/goroutine?debug=1

![](/uploads/201707/14d3039b83704c78.png)
##go-torch
１．安装go-torch
go-torch是uber开发的基于pprof的图形堆栈跟踪工具，能更直观的展现应用在执行中每个函数对CPU的使用情况。安装教程地址：https://github.com/uber/go-torch#integrating-with-your-application

下载go-torch go源码到go的src目录：
```shell
$ go get github.com/uber/go-torch
```
用git下载FlameGraph到go-torch根目录：
```shell
$ cd $GOPATH/src/github.com/uber/go-torch
$ git clone https://github.com/brendangregg/FlameGraph.git
```
安装依赖及测试包：
```sehll
$ go get github.com/Masterminds/glide
$ cd $GOPATH/src/github.com/uber/go-torch
$ glide install
```
测试：
```shell
$ go test ./...
```
２．用go-torch做堆栈跟踪
```shell
ray@ray-pc:~/go_workspace/src/github.com/uber/go-torch$ go-torch --seconds=10 --url=http://localhost:8080/debug/pprof/profile
INFO[10:44:53] Run pprof command: go tool pprof -raw -seconds 10 http://localhost:8080/debug/pprof/profile
INFO[10:45:03] Writing svg to torch.svg
```
在这里，我们跟踪了10秒，go-torch在当前目录生成了torch.svg文件，用相应的svg查看器打开：
![](/uploads/201707/14d33956319abcb3.png)

生成SVG中，每一条的长度表示当前函数调用耗时，长度越长用时越大。可以点击search来查找相应函数的执行情况：
![](/uploads/201707/14d33a08941da554.png)

找到函数后，go-torch会以粉红色高亮显示：
![](/uploads/201707/14d33a246408cf5f.png)

点击查找到的函数，查看更详细的信息：
![](/uploads/201707/14d33a3034da2987.png)

如上图所示，go-torch抓取了main.getUserInfoHandler的３个样本，耗时占12.5%。

#测试
测试分为benchmark性能测试和一般的测试test。Golang在标准库中的包testing提供了对benchmark和test的测试支持，用`go test`命令测试。如我们创建一个叫test的目录，用于作测试用：
![](/uploads/201707/14d33c1c510973f6.png)
测试文件
## benchmark
benchmark测试函数格式，函数以Benchmark开头:
`func BenchmarkXxx(*testing.B)`

实例：
```go
package test

import (
	"net/http"
	"testing"
)

// Benchmarking

func BenchmarkGetUserInfo(b *testing.B) {
	for i := 0; i < b.N; i++ {
		http.Get("http://localhost:8110/usercenter/getUserInfo/440858")
	}
}

func BenchmarkGetUserInfoDetail(b *testing.B) {
	for i := 0; i < b.N; i++ {
		http.Get("http://localhost:8110/usercenter/getUserInfoDetail/440858")
	}
}
```
```shell
$ go test -bench=.
```
![](/uploads/201707/14d344ea0e8ef0e5.png)
如上图，benchmark测试显示GetUserInfo执行了50次，每次耗时24695569纳秒，约为24.7毫秒。
可以给benchmark测试指定参数，如要测试GetUserInfoDetail，时间为5秒，指定参数-cpuprofile和-memprofile，CPU和内存分配的信息会保存到cpu.out和mem.out：
```shell
$ go test -bench=GetUserInfoDetail -benchtime=5s -cpuprofile cpu.out -memprofile mem.out
```
![](/uploads/201707/14d346b5353c3a01.png)

在得到CPU和内存的信息后，用pprof分析结果。
###benchcmp
安装：
```shell
$ go get golang.org/x/tools/cmd/benchcmp
```
下载完成后，编译，将可执行程序复制到/usr/local/bin。
```shell
$ go test -run=None -bench=MemAlloc -count=10000 ./... > old.txt
$ go test -run=None -bench=MemAlloc -count=10000 ./... > new.txt
```
benchcmp用来比较两次benchmark的结果：
```shell
$ benchcmp old.txt new.txt
```
![](/uploads/201707/14d34ecf894e2158.png)
## test
一般的test测试函数格式，函数以Test开头：
`func TestXxx(*testing.T)`

实例：
```go
package test

import (
	"log"
	"net/http"
	"testing"
)

// Tests

func TestGetUserInfo(t *testing.T) {
	log.Println("Testing...")
	http.Get("http://localhost:8110/usercenter/getUserInfo/440858")
	log.Println("Test complete.")
}
```
```shell
$ go test -run ''
```
![](/uploads/201707/14d347b96af8635a.png)

关于测试的详细介绍，请参见文档：https://golang.org/pkg/testing/

#常见问题
##网络
１．在并发测试过程中，由于测试工具请求很快，服务端依赖于网络中的其他服务机器（如数据库服务器、redis等），导致网络延时，如：
![](/uploads/201707/14d348b88a012a6b.png)
２．在测试过程中，服务端在很短的时间内收到较多请求，当redis或其他服务起的socket连接还没来得及关闭，整个连接池的连接已被用完，此时会到导致问题１一样的问题。
##代码
１．新建变量及赋值
应该在代码中尽量减少变量在循环体中定义，应为这会造成内存分配问题：
实例：
```go
package test

import (
	"testing"
)

func BenchmarkMemAlloc(b *testing.B) {
	b.N = 100
	for i := 0; i < b.N; i++ {
		bubblesort()
	}
}

func bubblesort() {
	array := []int{12, -4, 5, 29, 43, 2, 0, 3, -45, 21}
	for i := 0; i < len(array)-1; i++ {
		for j := i + 1; j < len(array); j++ {
			var temp int
			if array[i] > array[j] {
				temp = array[i]
				array[i] = array[j]
				array[j] = temp
			}
		}
	}
}
```
以上是一个benchmark测试，我们将冒泡排序函数bubblesort()测试1,000,000次（100x10000)，如果将`var temp int`这行代码放到循环体的最里层。
```shell
$ go test -bench=MemAlloc -count=10000 -cpuprofile cpu.out -memprofile mem.out
```
![](/uploads/201707/14d34ca5126df694.png)
通过benchmark测试，我们可以看到，执行1,000,000次所用时间为41.116秒，总共分配了244431个内存对象。
现在，将`var temp int`这行代码放到bubblesort函数的最上层，即：
```go
func bubblesort() {
	var temp int
	array := []int{12, -4, 5, 29, 43, 2, 0, 3, -45, 21}
	for i := 0; i < len(array)-1; i++ {
		for j := i + 1; j < len(array); j++ {
				...
			}
		}
	}
}
```
![](/uploads/201707/14d34d278d8b2e74.png)
对比代码`var temp int`放在循环最里层和最外层，在运行时间基本一样的情况下，内存分配从244431下降到134112，这减少了内存占用和大量的垃圾回收GC操作。所以，在开发中对代码的合理编写，会极大影响到程序的性能。

#参考资料

[Profiling Go Programs](https://blog.golang.org/profiling-go-programs)
[Profiling and optimizing Go web applications](http://artem.krylysov.com/blog/2017/03/13/profiling-and-optimizing-go-web-applications/)
[go-torch](https://github.com/uber/go-torch)
[go-wrk](https://github.com/adjust/go-wrk)
[Golang测试包官方文档](https://golang.org/pkg/testing/)
[benchcmp命令](https://godoc.org/golang.org/x/tools/cmd/benchcmp)
[How to write benchmarks in Go](https://dave.cheney.net/2013/06/30/how-to-write-benchmarks-in-go)
[Beautifully Simple Benchmarking with Go](http://www.soroushjp.com/2015/01/27/beautifully-simple-benchmarking-with-go/)
[Profiling Your Go Programs](https://www.youtube.com/watch?v=7LCgsfHlMv4&list=PL0yG7GruQkdI-H7HeFNTRc8d3yd6j5BB-&index=1)
[Golang UK Conference 2016 - Dave Cheney - Seven ways to Profile Go Applications](https://www.youtube.com/watch?v=2h_NFBFrciI&index=2&list=PL0yG7GruQkdI-H7HeFNTRc8d3yd6j5BB-)
[Profiling and Optimizing Go](https://www.youtube.com/watch?v=N3PWzBeLX2M&list=PL0yG7GruQkdI-H7HeFNTRc8d3yd6j5BB-&index=3)
