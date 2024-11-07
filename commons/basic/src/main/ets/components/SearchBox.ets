@Preview
@Component
export struct SearchBox {
  @State text: string = '搜索...'
  @State icon: ResourceStr = $r('sys.media.ohos_ic_public_search_filled')

  build() {
    Row() {
      Row({space: 8}) {
        Image(this.icon)
          .width(16)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
        Text(this.text)
          .fontColor($r('app.color.white'))
      }
      .width('100%')
      .height(40)
      .borderRadius(20)
      .backgroundColor($r('app.color.black'))
      .opacity(0.3)
      .padding({left: 12, top: 9, bottom: 9})
    }
    .padding({left: 16, right: 16})
    .width('100%')
  }
}