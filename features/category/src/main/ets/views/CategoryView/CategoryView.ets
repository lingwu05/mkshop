import { BreakPointType, CategoryChildrenItem, CategoryItem, TitleNavBar } from "basic"
import { BusinessVariable, GlobalVariable } from "basic/src/main/ets/constants/GlobalVariable"
import text from "@ohos.graphics.text"

@Component
export struct CategoryView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  @StorageProp(BusinessVariable.CATEGORY_DATA)
  catagoryList: CategoryItem[] = []
  @State activeIndex: number = 0

  aboutToAppear(): void {

  }

  build() {
    Column() {
      TitleNavBar({title: '分类', isLeftIconShow: false})
        .width('100%')
      Row() {
        // 分类列表
        Column() {
          ForEach(this.catagoryList, (item: CategoryItem, index) => {
            Text(item.name)
              .width('100%')
              .height(56)
              .backgroundColor(this.activeIndex == index ? '#191919' : '#fff')
              .fontColor(this.activeIndex == index ? '#fff' : '#191919')
              .fontSize(13)
              .onClick(() => {
                this.activeIndex = index
              })
              .textAlign(TextAlign.Center)
          })
        }
        .width(88)
        // 具体商品类别栏目
        Scroll() {
          Column() {
            // 顶部图片
            Image(this.catagoryList[this.activeIndex]?.picture || '')
              .width('100%')
              .height(136)
              .objectFit(ImageFit.Contain)
              .backgroundColor('#f6f6f6')
              .borderRadius(8)
              .margin({ bottom: 8 })

            GridRow({columns: {
              sm: 2,
              md: 3,
              lg: 4
            }, gutter: 8}) {
              ForEach(this.catagoryList[this.activeIndex]?.children || [], (item: CategoryChildrenItem) => {
                GridCol() {
                  Column() {
                    // 图片
                    Image(item.picture)
                      .width(64)
                      .aspectRatio(1)
                    Text(item.name)// 文本
                      .fontSize(14)
                      .fontColor($r('[basic].color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#f6f6f6')
                .borderRadius(8)
              })
            }
          }
          .padding(8)
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({
      top: this.topHeight
    })
  }
}