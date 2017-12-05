//
//  SOAPConstant.h
//  Lottery
//
//  Created by YanYan on 6/8/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//


#define ChannelID       @"10000"

#define SOAPMessageTemplate @"<v:Envelope xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                                    <v:Header>\
                                    %@\
                                    </v:Header>\
                                    <v:Body>\
                                    %@\
                                    </v:Body>\
                                </v:Envelope>"

#define SOAPHeaderTemplate @"<n0:UserName xmlns:n0=\"NameSpaceURI\">%@</n0:UserName>\
                            <n1:UserPsw xmlns:n1=\"NameSpaceURI\">%@</n1:UserPsw>\
                            <n2:Client xmlns:n2=\"NameSpaceURI\">%@</n2:Client>\
                            <n3:Version xmlns:n3=\"NameSpaceURI\">%@</n3:Version>\
                            <n4:Channel xmlns:n4=\"NameSpaceURI\">%@</n4:Channel>"

/*
1. api name
2. name space
3. argument
 <arg1 i:type="d:string">kOzhUp+46lXFPgfr5+hlFA==</arg1>
 */
#define SOAPBodyTemplate @"<n5:%@ c:root=\"1\" id=\"o0\" xmlns:n5=\"NameSpaceURI\">%@</n5:%@>"

