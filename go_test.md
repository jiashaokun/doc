# go test

[单元测试]

---

- **go test** 注释后必须多空出一行，也就是 **//** 下一行要预留为空行，否则go解析的时候会把下一行解析成注释行

---

go test 的相关使用介绍
## 1. 条件build
### a.go
```go
// +build !test
    ...todo code
```
### b.go
```go
//+build test
    ...todo code
```
- 执行 go build -tags "test" 时，实际编译 b.go 
- +build 是指的条件编译 test 指的是 -tags 后的内容 ! 是非的意思
## 2. go test 最大操作范围：包 包
```go
//在packageName目录下,包与包用空格间隔
go test -tags "test" funnel/tasks net/http
```
## 3.go test 最小操作范围：func
```go
go test -run=TestFunctionName
//测试当前包下面的TestFunctionName函数
```

>* 测试文件需要与被测试文件保持同级目录 demo.go  demo_test.go
>* 文件名命名规则：被测试文件的文件名_test.go
>* 测试函数名命名：Test+测试场景的函数名(t *testing.T)
>* 一个test.go文件内，可以包含多个测试场景
>* 一个包中的抽象出的公共测试函数，以 包名_test.go 命名文件


## 4. go test 常用命令列表
>* -v 无论用例是否测试通过都会显示结果，不加"-v"表示只显示未通过的用例结果
>* -run 测试某个函数 go test -run=TestFunctionName
>* -cover 输出测试代码覆盖率
>* -c 编译pkg.test但不运行
>* -i 安装测试以来的package包，但不运行
>* -o 指定用于测试的可执行文件的名称
>* t.Log,t.Logf  打印正常信息(结果与预期相符)
>* t.Error，t.Errorf 打印错误信息（结果与预期不符）
