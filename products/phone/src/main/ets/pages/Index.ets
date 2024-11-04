import { TabItem } from 'basic';
import { CartView } from 'cart';
import { CategoryView } from 'category';
import { HomeView } from 'home';
import { MineView } from 'mine';

@Entry
@Component
struct Index {
  @State activeIndex: number = 0
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
        .fontColor($r('app.color.black'))
        .lineHeight(14)
    }
  }

  build() {
    Tabs({barPosition: BarPosition.End}) {
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
    .height('100%')
    .width('100%')
  }
}