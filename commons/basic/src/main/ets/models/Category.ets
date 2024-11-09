import { GoodsItem } from "./Goods"

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