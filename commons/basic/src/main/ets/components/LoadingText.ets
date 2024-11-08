@Component
export struct LoadingText {
  @Prop title: string = 'MKSHOP'
  xOffset: number = 0

  aboutToAppear(): void {
    animateTo({ duration: 200, iterations: -1, playMode: PlayMode.AlternateReverse }, () => {
      this.xOffset = 4
    })
  }

  build() {
    RelativeContainer() {
      Text(this.title)
        .alignRules({
          center: {anchor: '__container__', align: VerticalAlign.Center},
          middle: {anchor: '__container__', align: HorizontalAlign.Center}
        })
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontStyle(FontStyle.Italic)
        .fontColor("#e93323")
        .translate({
          x: -this.xOffset,
          y: -this.xOffset
        })

      Text(this.title)
        .alignRules({
          center: {anchor: '__container__', align: VerticalAlign.Center},
          middle: {anchor: '__container__', align: HorizontalAlign.Center}
        })
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontStyle(FontStyle.Italic)
        .fontColor("#75fbfd")
        .translate({
          x: this.xOffset,
          y: this.xOffset
        })

      Text(this.title)
        .alignRules({
          center: {anchor: '__container__', align: VerticalAlign.Center},
          middle: {anchor: '__container__', align: HorizontalAlign.Center}
        })
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontStyle(FontStyle.Italic)
        .fontColor(Color.White)
    }
    .backgroundColor("rgba(0,0,0,0.1)")
  }
}