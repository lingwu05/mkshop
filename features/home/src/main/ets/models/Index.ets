export interface BannerItem {
  imgUrl: string
  hrefUrl: string
  id: string
  type: string
}

// 分类目录
export interface CategoryChildrenItem {
  id: string
  name: string
  picture: string
  children: null
  goods: null
}

export interface CategoryItem {
  id: string
  name: string
  picture: string
  children: CategoryChildrenItem[]
  goods: GoodsItem[]
}

export interface GoodsItem {
  id: string
  name: string
  picture: string
  desc: string
  price: string
  orderNum: number
}

export interface SimpleGoodsItem {
  id: string
  name: string
  picture: string
}

// 特惠推荐返回数据 爆款推荐 一站买全
export interface Goods {
  counts: number
  pageSize: number
  pages: number
  page: number
  items: GoodsItem[]
}

export interface HotGoodsItem {
  id: string
  title: string
  goodsItems: Goods
}

export interface HotGoods {
  id: string
  title: string
  subTypes: HotGoodsItem[]
}

// 推荐卡片商品 响应数据
export interface RecomGoodsItem {
  id: string
  name: string
  price: string
  picture: string
  payCount: number
}

export interface RecomQueryParam {
  limit: number
}

export interface DiscountBuilderParam {
  mainTitle: string
  subTitle: string
  list: GoodsItem[]
  bgc: string
}
