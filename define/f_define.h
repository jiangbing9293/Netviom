//
//  f_define.h
//  Supereye
//
//  Created by jiang bing on 15/6/11.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#ifndef Supereye_f_define_h
#define Supereye_f_define_h

const char* AP_SETPARA_POST = "POST /cgi-bin/setparam.cgi HTTP/1.1\r\n"
                    "Accept-Language: zh-CN\r\n"
                    "Referer: http://%s\r\n"
                    "Accept: application/json, text/javascript, */*; q=0.01\r\n"
                    "Content-Type: application/x-www-form-urlencoded\r\n"
                    "x-requested-with: XMLHttpRequest\r\n"
                    "Accept-Encoding: gzip, deflate\r\n"
                    "User-Agent: Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; EIE10;ENUSWOL)\r\n"
                    "Host: %s\r\n"
                    "Content-Length: %d\r\n"
                    "DNT: 1\r\n"
                    "Connection: Keep-Alive\r\n"
                    "Cache-Control: no-cache\r\n\n"
                    "%s";

const char* AP_SET_WIFI_CMD = "WLAN_Enabled=on&WLAN_SSID=%s&WLAN_Channel=1&WLAN_NetworkType=0&WLAN_AuthMode=4&WLAN_EncrypType=2&WLAN_DefaultKeyID=1&WLAN_Key1=&WLAN_Key2=&WLAN_Key3=&WLAN_Key4=&WLAN_Key1Type=0&WLAN_Key2Type=0&WLAN_Key3Type=0&WLAN_Key4Type=0&WLAN_WPAPSKKey=%s";

const char* AP_DHCP_CMD = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:tt=\"http://www.onvif.org/ver10/schema\" xmlns:tds=\"http://www.onvif.org/ver10/device/wsdl\" xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\"><soap:Header></soap:Header><soap:Body><tds:SetNetworkInterfaces><tds:InterfaceToken>eth0</tds:InterfaceToken><tds:NetworkInterface token=\"eth0\"><tt:IPv4><tt:Enabled>true</tt:Enabled><tt:DHCP>true</tt:DHCP></tt:IPv4></tds:NetworkInterface></tds:SetNetworkInterfaces></soap:Body></soap:Envelope>";

const char* AP_REBOOT_CMD = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:tds=\"http://www.onvif.org/ver10/device/wsdl\" xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\"><soap:Header></soap:Header><soap:Body><tds:SystemReboot></tds:SystemReboot></soap:Body></soap:Envelope>";

const char* AP_POST = "POST /onvif/services HTTP/1.1\r\n"
                    "method: POST\r\n"
                    "Accept-Language: zh-CN\r\n"
                    "Referer: http://%s\r\n"
                    "Accept: text/plain, */*; q=0.01\r\n"
                    "Content-Type: application/soap+xml; charset=utf-8\r\n"
                    "x-requested-with: XMLHttpRequest\r\n"
                    "Accept-Encoding: gzip, deflate\r\n"
                    "User-Agent: Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; EIE10;ENUSWOL)\r\n"
                    "Host: %s\r\n"
                    "Content-Length: %d\r\n"
                    "Connection: Keep-Alive\r\n"
                    "Cache-Control: no-cache\r\n"
                    "Authorization: Basic %s\r\n\n"
                    "%s";

/****************************************************
 * Wi-Fi设置界面控件tag
 *******************************************/
typedef enum
{
    DEVICE_USERNAME,
    DEVICE_PASSWORD,
    DEVICE_SSID,
    DEVICE_WIFI_PASSWORD
}WiFi_Set_Tag;

/****************************************************
 * Wi-Fi设置状态
 *****************************************************/
typedef enum
{
    CONNECT_DEVICE,
    CONNECT_FAIL,
    CONNECT_SUCCESS,
    SET_WIFI,
    SET_DHCP_ENABLE,
    REBOOT,
    UNAUTHORIZED
}Set_WiFi_Status;

#endif
