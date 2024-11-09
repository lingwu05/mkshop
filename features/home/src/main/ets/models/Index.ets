import { GoodsItem } from "basic"

export interface BannerItem {
  imgUrl: string
  hrefUrl: string
  id: string
  type: string
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



export interface DiscountBuilderParam {
  mainTitle: string
  subTitle: string
  list: GoodsItem[]
  bgc: string
}

@Observed
export class ListDataSource<T> implements IDataSource {
  // 内部用来触发UI更新对象
  listeners: DataChangeListener[] = []
  // 管理数据
  list: T[] = []

  // 实现了 IDataSource 接口
  // 接口要求我们必须定义四个方法：getData、totalCount、registerDataChangeListener、unregisterDataChangeListener
  // 读取对应下标的数据
  getData(index: number): T {
    return this.list[index]
  }

  // 返回数据总长度
  totalCount(): number {
    return this.list.length
  }

  // 保存单个数据
  setData(item: T) {
    // 只会更新数据，不会更新UI
    this.list.push(item);
    // 更新UI
    this.notifyDataAdd(this.list.length - 1);
  }

  // 更新所有数据
  setList(list: T[]) {
    this.list = list;
    this.notifyDataReload();
  }

  // 下面的代码照搬官方的即可
  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}
