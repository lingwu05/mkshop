import { HttpRequest } from 'basic'
import { BannerItem, CategoryItem, GoodsItem, HotGoods, RecomGoodsItem, } from '../models/Index'

export class HomeHttpApi {
  // 获取轮播图数据
  static getBannerData() {
    return HttpRequest.get<BannerItem[]>('/home/banner')
  }
  // 获取分类栏目数据
  static getCategoryData() {
    return HttpRequest.get<CategoryItem[]>('/home/category/head')
  }
  // 获取特惠推荐下的商品列表
  static getSpecialData() {
    return HttpRequest.get<HotGoods>('/hot/preference')
  }
  // 获取爆款推荐下的商品列表
  static getHotData() {
    return HttpRequest.get<HotGoods>('/hot/inVogue')
  }
  // 获取一站买全下的商品列表
  static getOneData() {
    return HttpRequest.get<HotGoods>('/hot/oneStop')
  }
  // 获取新鲜好物下的商品列表
  static getFreshData() {
    return HttpRequest.get<GoodsItem[]>('/home/new')
  }
  // 获取推荐下的卡片商品列表
  static getRecomData(param: object) {
    return HttpRequest.get<RecomGoodsItem[]>('/home/recommend', param)
  }
}