# Lex-Yacc
## < Call graph >
 
 
### 1.  개요
 
 Call graph는 코드 내의 함수들 사이의 호출을 시각화하는 그래프이다.
 
 렉스와 야크를 이용해 c언어 코드를 파싱한 후에 함수 호출과 관련한 내용 (Ex. 어떤 함수가 어떤 함수를 호출하는지, 몇 번 호출하는지, 코드의 몇 번째 줄에서 호출하는지 등)을 자료구조에 저장한다. 
 
 그 후 콜 그래프 형태로 출력하는 프로그램을 작성한다. 
  
### 2.  순서
 (1) Yacc Program을 실행 시 C 코드를 읽어오게 된다.

<pre><code>컴파일 방법
$ lex lex.l
$ yacc –d yacc.y
$ cc y.tab.c lex.yy.c –o proc
$ ./proc < test.c ( proc 실행파일을 실행시킴 )
</code></pre>
	
 (2) 코드의 내용을 분석한다. (test.c 파일의 내용을 읽어옴)
 
 <pre><code>$ cat < func.c
#include <stdio.h>

int a(int dd, int dsg);
int func(int x, int y)
{
        a();
        bbb(a, x);
        a();
        dgs();
}
int main()
{
        int c;
        int d=4;
        func();
        func();
        for(a=fucn(); a<10; a++){
                asdfasf();
        }
        while(a){
        bbbbb();
        }
        aa();
        bb(3,5);
        int b = 10;
        int c = aa() + ac();
        printf();
        cc(a,b);
        bb(3, 32);
        for(c=0; i<10; i++){
                asdfdsf();
        }

        return ret() + asdfsdsfdsf();
}
int a(int dd, int dsg)
{
        prisadfadsff("%s");
        b();
        ebe();
        dsgwdg();
}
int dsgwdg(){
        printf();
}
int bdd(int x, int y){
        ff();
}
int bb(){
        a();
        func();
        a();
}

</code></pre>
 
 (3) 코드 내에서의 함수 호출 관계를 파악하고 자료구조에 저장한다.
 
 (4) 자료구조에 저장된 내용을 콜 그래프의 형태로 출력한다.  
 
![result](https://user-images.githubusercontent.com/43088990/81096890-04d67b00-8f42-11ea-9083-30b68cf91ffa.jpg)
