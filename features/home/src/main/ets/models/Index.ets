export interface BannerItem {
  img: string
}

export interface CategoryItem {
  name: string
  img: string
  bgc: string
}

export interface GoodsItem {
  name: string
  img: string
  desc: string
  price: string
}

export interface DiscountBuilderParam {
  mainTitle: string
  subTitle: string
  list: GoodsItem[]
  bgc: string
}