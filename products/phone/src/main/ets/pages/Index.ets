import { BreakPointType, Logger, TabItem } from 'basic';
import { GlobalVariable } from 'basic/src/main/ets/constants/Index';
import { CartView } from 'cart';
import { CategoryView } from 'category';
import { HomeView } from 'home';
import { MineView } from 'mine';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @StorageProp(GlobalVariable.SAFE_AREA_BOTTOM) bottomHeight: number = 0
  @State activeIndex: number = 0
  @StorageProp(GlobalVariable.BREAK_POINT_KEY) breakPoint: string = ''
  @Provide pageStack: NavPathStack = new NavPathStack() // 声明路由栈对象
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
    Navigation(this.pageStack) {
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
          .width('100%')
          .height('100%')
        })
      }
      .onTabBarClick((index) => {
        this.activeIndex = index
        promptAction.showToast({message: this.breakPoint})
      })
      .vertical(new BreakPointType({
        xs: false,
        sm: false,
        md: false,
        lg: true
      }).getValue(this.breakPoint))
      .barHeight(new BreakPointType({
        xs: 50,
        sm: 50,
        md: 50,
        lg: 220
      }).getValue(this.breakPoint))
      .animationDuration(new BreakPointType({
        xs: 300,
        sm: 300,
        md: 300,
        lg: 0
      }).getValue(this.breakPoint))
      .height('100%')
      .width('100%')
      .padding({bottom: this.bottomHeight})
    }
    .mode(NavigationMode.Stack)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}