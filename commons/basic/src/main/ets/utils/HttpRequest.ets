import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { GlobalVariable } from '../constants/Index'

const instance = axios.create({
  baseURL: GlobalVariable .BASE_URL, // 请求地址
  timeout: 2000 // 超时请求时长 单位 ms
})

// 添加请求拦截器
instance.interceptors.request.use((config:InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  return config;
}, (error:AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});

// 添加响应拦截器
instance.interceptors.response.use((response:AxiosResponse)=> {
  // 对响应数据做点什么
  return response.data;
}, (error:AxiosError)=> {
  // 对响应错误做点什么
  return Promise.reject(error);
});

export class HttpRequest {
  static get<T>(url: string, params? :object): Promise<T> {
    return instance.get<null, T>(url, {params: params})
  }

  static post<T>(url: string, data? :object): Promise<T> {
    return instance.get<null, T>(url, data)
  }

  // 修改方法
  static put<T>(url: string, data?: object): Promise<T> {
    return instance.put<null, T>(url, data)
  }

  // 删除方法
  static delete<T>(url: string, params?: object): Promise<T> {
    return instance.delete<null, T>(url, { params })
  }
}