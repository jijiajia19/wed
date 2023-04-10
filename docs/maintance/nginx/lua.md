-- coding: utf-8



local function test()

 --注释

 print("test lua environment!")

 local a="test"

 print(a)



 local b=[[sfaadsfsa



 sfaafs

 ]]

 print(b)



 local flag=nil

 print(flag)

 if flag~=nil then

   --连接符不能有nil，有则报错

   print("===========>"..flag)

 end



 local counter=0

 local max=19

 while counter<=max do

  --print(counter)

  counter=counter+1

  --io.write("too young, too simple!\n")

 end



 local sum=0

 for i=100,2,-2 do

  sum=sum+i

 end

 print(sum)



end





local function method_case(x,y)

 return x+y,"第二个返回值"

end



--chcp 65001 控制台解决乱码

test()

local v,returnStr=method_case(18,1)

print(v,returnStr)



local function showTable()

  local t={name="jacle",age=35,hobby="看书"}

  t.name="小明"

  print(t,t.name)



  local arr = { "string", 100, "dog", function()

  print("wangwang!")

  return 1

 end }

  print(arr[1])



 --遍历数组，索引和数值

 for k, v in pairs(arr) do

  print(k, v)

 end

end

showTable()



--成员函数

local function mainJ()

 local person = { name = '旺财', age = 18 }

 function person.eat(food)

  print(person.name .. " eating " .. food)

 end



 person.eat("骨头")

end

mainJ()