import { BreakPointType, Logger, TabItem } from 'basic';
import { GlobalVariable } from 'basic/src/main/ets/constants/Index';
import { CartView } from 'cart';
import { CategoryView } from 'category';
import { HomeView } from 'home';
import { MineView } from 'mine';

@Entry
@Component
struct Index {
  @State activeIndex: number = 0
  @StorageProp(GlobalVariable.BREAK_POINT_KEY) breakPoint: string = ''
  tabList: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]

  @Builder tabBarBuilder(item: TabItem, index: number) {
    Column({space: 3}) {
      Image(this.activeIndex === index ? item.active : item.normal)
        .width(24.14)
        .aspectRatio(1)
      Text(item.text)
        .fontSize(11)
        .fontColor($r('[basic].color.black'))
        .lineHeight(14)
    }
  }

  aboutToAppear(): void {
    Logger.info("正常打印")
    Logger.error("错误啦")
    Logger.warn("警告啦")
  }

  build() {
    Tabs({barPosition: new BreakPointType({
      xs: BarPosition.End,
      sm: BarPosition.End,
      md: BarPosition.End,
      lg: BarPosition.Start
    }).getValue(this.breakPoint)}) {
      ForEach(this.tabList, (item:TabItem, index) => {
        TabContent() {
          if (index === 0) {
            HomeView()
          } else if (index === 1) {
            CategoryView()
          } else if (index === 2) {
            CartView()
          } else {
            MineView()
          }
        }
        .tabBar(this.tabBarBuilder(item, index))
      })
    }
    .onTabBarClick((index) => {
      this.activeIndex = index
    })
    .vertical(new BreakPointType({
      xs: false,
      sm: false,
      md: false,
      lg: true
    }).getValue(this.breakPoint))
    .height('100%')
    .width('100%')
  }
}