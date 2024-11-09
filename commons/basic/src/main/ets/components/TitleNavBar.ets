@Component
export struct TitleNavBar {
  title: string = '测试'
  leftIcon: ResourceStr = $r('app.media.ic_public_left')
  rightIcon: ResourceStr = $r('app.media.ic_public_more')
  isLeftIconShow: boolean = true
  isRightIconShow: boolean = true
  onLeftClick: () => void = () => {}
  onRightClick: () => void = () => {}

  build() {
    RelativeContainer() {
      if (this.isLeftIconShow) {
        Image(this.leftIcon)
          .width(24)
          .aspectRatio(1)
          .fillColor('#191919')
          .alignRules({
            left: {anchor: '__container__', align: HorizontalAlign.Start},
            center: {anchor: '__container__', align: VerticalAlign.Center}
          })
      }
      Text(this.title)
        .fontSize(17)
        .fontWeight(700)
        .lineHeight(22)
        .alignRules({
          middle: {anchor: '__container__', align: HorizontalAlign.Center},
          center: {anchor: '__container__', align: VerticalAlign.Center}
        })
      if (this.isRightIconShow) {
        Image(this.rightIcon)
          .width(24)
          .aspectRatio(1)
          .fillColor('#191919')
          .alignRules({
            right: {anchor: '__container__', align: HorizontalAlign.End},
            center: {anchor: '__container__', align: VerticalAlign.Center}
          })
      }
    }
    .padding({
      left: 10,
      right: 10
    })
    .width('100%')
    .height(50)
  }
}