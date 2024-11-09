export interface GoodsItem {
  id: string
  name: string
  picture: string
  desc: string
  price: string
  orderNum: number
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