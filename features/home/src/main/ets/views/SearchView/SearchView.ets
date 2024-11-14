import { GlobalVariable } from 'basic/src/main/ets/constants/Index'
import { promptAction } from '@kit.ArkUI';

// 跳转页面入口函数
@Builder
export function PageSearchBuilder() {
  SearchView()
}

@Component
struct SearchView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP) topHeight: number = 0
  @State value: string = ''
  pageStack : NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Column() {
        Row({space: 8}) {
          Image($r('[basic].media.ic_public_left'))
            .width(24)
            .aspectRatio(1)
            .onClick(() => {
              this.pageStack.pop() // 返回上一页
              return true
            })
          Search({value: this.value, placeholder: '商品关键字'})
            .searchButton('搜索')
            .height(40)
            .layoutWeight(1)
            .onChange((value: string) => {
              this.value = value
            })
            .defaultFocus(true)
        }
        .width('100%')
        .height(56 + this.topHeight)
        .padding({top: this.topHeight, bottom: 8, left: 8, right: 16})
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [["#ffdebfee", 0], [$r("[basic].color.white"), 1]]
        })
      }
      .width('100%')
      .height('100%')
    }
    .onReady((data) => {
      this.pageStack = data.pathStack
    })
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}