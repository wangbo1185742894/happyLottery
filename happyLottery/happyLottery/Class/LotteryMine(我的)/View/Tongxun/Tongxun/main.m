//
//  main.m
//  Tongxun
//
//  Created by 阿兹尔 on 2018/5/12.
//  Copyright © 2018年 王博. All rights reserved.
//

#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include<string.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<sys/socket.h>
#include<sys/wait.h>

#define PORT 1500//端口号
#define BACKLOG 5/*最大监听数*/

int main(){
    int sockfd,new_fd;/*socket句柄和建立连接后的句柄*/
    struct sockaddr_in my_addr;/*本方地址信息结构体，下面有具体的属性赋值*/
    struct sockaddr_in their_addr;/*对方地址信息*/
    int sin_size;
    
    sockfd=socket(AF_INET,SOCK_STREAM,0);//建立socket
    if(sockfd==-1){
        printf("socket failed:%d",errno);
        return -1;
    }
    my_addr.sin_family=AF_INET;/*该属性表示接收本机或其他机器传输*/
    my_addr.sin_port=htons(PORT);/*端口号*/
    my_addr.sin_addr.s_addr=htonl(INADDR_ANY);/*IP，括号内容表示本机IP*/
    bzero(&(my_addr.sin_zero),8);/*将其他属性置0*/
    if(bind(sockfd,(struct sockaddr*)&my_addr,sizeof(struct sockaddr))<0){//绑定地址结构体和socket
        printf("bind error");
        return -1;
    }
    listen(sockfd,BACKLOG);//开启监听 ，第二个参数是最大监听数
    int i = 0;
    
    while(1){
        sin_size=sizeof(struct sockaddr_in);
        new_fd=accept(sockfd,(struct sockaddr*)&their_addr,&sin_size);//在这里阻塞知道接收到消息，参数分别是socket句柄，接收到的地址信息以及大小
        if(new_fd==-1){
            printf("receive failed");
        } else{
            printf("receive success");
            char  *string = "Hello World";
            send(new_fd,string,12,0);//发送内容，参数分别是连接句柄，内容，大小，其他信息（设为0即可）
    
        }
    }
    return 0;
}
