import { BreakPointEnum, BreakPointType, CategoryItem, GoodsItem, HttpRequest, RecomGoodsItem,
  RecomQueryParam } from "basic"
import { SearchBox, LoadingText, Loading } from "basic/src/main/ets/components/Index"
import { BusinessVariable, GlobalVariable, PagePath } from "basic/src/main/ets/constants/GlobalVariable"
import { HomeHttpApi } from "../../api/Index"
import { BannerItem,  DiscountBuilderParam,
  ListDataSource, } from "../../models/Index"
import { promptAction, router } from "@kit.ArkUI"

@Builder
export function PageHomeBuilder() {
  HomeView()
}

@Component
export struct HomeView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP) topHeight: number = 0
  @StorageProp(GlobalVariable.BREAK_POINT_KEY) breakPoint: string = ''
  @State bannerList: BannerItem[] = []
  @State categoryList: CategoryItem[] = []
  @State saleGoodsList: GoodsItem[] = []
  @State hotGoodsList: GoodsItem[] = [] // 爆款推荐下的商品列表
  @State oneGoodsList: GoodsItem[] = [] // 一站买全下的商品列表
  @State freshGoodsList: GoodsItem[] = [] // 新鲜好物商品列表
  recomGoodsDataSource: ListDataSource<RecomGoodsItem> = new ListDataSource()

  @State isRefreshing: boolean = false // Refresh刷新
  @State page: number = 1
  @State hasNextPage: boolean = true
  @State isReachLoad: boolean = false
  @State searchOpacity: number = 0
  @State yOffset: number = 0
  @State isLoading: boolean = false
  scroller: Scroller = new Scroller()

  @Consume pageStack: NavPathStack;

  async aboutToAppear() {
    this.isLoading = true
    await this.getHomeData()
    await this.getRecomData()
    this.isLoading = false
  }

  // 获取推荐商品的数据
  async getRecomData() {
    const result = await HomeHttpApi.getRecomData({limit: this.page * 8} as RecomQueryParam)
    if (result.length || result.length == this.page * 8) {
      ++this.page
    } else {
      this.hasNextPage = false
      promptAction.showToast({message: '没有下一页了'})
    }
    this.recomGoodsDataSource.setList(result)
  }

  // 获取数据
  async getHomeData() {
    const result = await Promise.allSettled([
      HomeHttpApi.getBannerData(),
      HomeHttpApi.getCategoryData(),
      HomeHttpApi.getSpecialData(),
      HomeHttpApi.getHotData(),
      HomeHttpApi.getOneData(),
      HomeHttpApi.getFreshData(),
      this.getRecomData()
    ])
    if (result[0].status === "fulfilled") {
      this.bannerList = result[0].value
    }
    if (result[1].status === "fulfilled") {
      this.categoryList = result[1].value
      AppStorage.setOrCreate(BusinessVariable.CATEGORY_DATA, this.categoryList)
    }
    if (result[2].status === "fulfilled") {
      this.saleGoodsList = result[2].value.subTypes[0]?.goodsItems?.items
    }
    if (result[3].status === "fulfilled") {
      this.hotGoodsList = result[3].value.subTypes[0]?.goodsItems?.items
    }
    if (result[4].status === "fulfilled") {
      this.oneGoodsList = result[4].value.subTypes[0]?.goodsItems?.items
    }
    if (result[5].status === "fulfilled") {
      this.freshGoodsList = result[5].value
    }
  }

  @Builder refreshStyleBuilder() {
    Row() {
      Loading()
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder discountBuilder(param: DiscountBuilderParam) {
    Column({space: 8}) {
      Row({space: 10}) {
        Text(param.mainTitle)
          .fontSize(14)
          .fontWeight(500)
          .lineHeight(22)
          .fontColor('#434343')
        Text(param.subTitle)
          .fontSize(11)
          .fontWeight(400)
          .lineHeight(22)
          .fontColor('#6C6C6C')
      }
      .width('100%')
      List({space: 10}) {
        ForEach(param.list, (item: GoodsItem) => {
          ListItem() {
            Column() {
              Image(item.picture)
                .width(55)
                .aspectRatio(1)
                .margin({bottom: 8})
              Text('￥' + item.price)
                .fontSize(12)
                .fontWeight(500)
                .fontColor('#FF4B61')
                .lineHeight(12)
                .margin({bottom: 4})
              Text() {
                Span('立减')
                  .fontColor('#fff')
                  .fontSize(8)
                  .lineHeight(6)
                Span('90')
                  .fontColor('#fff')
                  .fontSize(10)
                  .lineHeight(8)
              }
              .textAlign(TextAlign.Center)
              .linearGradient({
                angle: 93,
                colors: [['#FD3F8F', 0], ['#FF773C', 1]]
              })
              .width(48)
              .height(20)
            }
            .padding(8)
            .width(71)
            .height(115)
            .backgroundColor('#fff')
          }
        })
      }
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .borderRadius(8)
    .layoutWeight(1)
    .padding(8)
    .backgroundColor(param.bgc)
  }

  @Builder
  cardGoodsBuilder(item: GoodsItem) {
    Column() {
      Image(item.picture)
        .width('100%')
        .aspectRatio(1)

      Text(item.name)
        .maxLines(2)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .fontSize(13)
        .fontWeight(300)
        .lineHeight(16.5)
        .fontColor('#434343')
        .margin({top: 10, bottom: 16})
        .width('100%')

      Row() {
        Text('￥ ' + item.price)
          .fontSize(13)
          .fontWeight(700)
          .lineHeight(12)
          .fontColor('#191919')
          .margin({right: 4})
        Text('￥ 999')
          .fontSize(8)
          .fontWeight(300)
          .lineHeight(12)
          .fontColor('#A6A3AD')
          .decoration({
            type:TextDecorationType.LineThrough
          })
        Blank()
        Text('2.9万+人付款')
          .fontSize(10)
          .fontWeight(300)
          .fontColor('#A6A3AD')
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('100%')
    }
    .width('100%')
    .borderRadius(8)
  }

  build() {
    NavDestination() {
      if (this.isLoading) {
      LoadingText()
      } else {
        RelativeContainer() {
          Refresh({refreshing: $$this.isRefreshing, builder: this.refreshStyleBuilder()}) {
            Scroll(this.scroller) {
              Column() {
                // 轮播图
                Swiper() {
                  ForEach(this.bannerList, (item: BannerItem) => {
                    Image(item.imgUrl)
                  })
                }
                .autoPlay(true)
                .width('100%')
                // 适配不同设备轮播图显示的个数
                .displayCount(
                  new BreakPointType({
                    // 1 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: 1,
                    md: 2,
                    lg: 3
                  })
                    .getValue(this.breakPoint)
                )
                // 适配不同组件的间距
                .itemSpace(
                  new BreakPointType({
                    // 0 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: 0,
                    md: 10,
                    lg: 20
                  })
                    .getValue(this.breakPoint)
                )
                .indicator(
                  this.breakPoint === BreakPointEnum.sm ?
                  DotIndicator.dot()
                    .itemWidth(8)
                    .itemHeight(4)
                    .color('#33191919')
                    .selectedItemWidth(24)
                    .selectedItemHeight(4)
                    .selectedColor('#191919') : false
                )

                // 分类
                Column() {
                  // 横向滚动商品目录
                  List({space: new BreakPointType({
                    // 0 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: 14,
                    md: 36,
                    lg: 72
                  })
                    .getValue(this.breakPoint)}) {
                    ForEach(this.categoryList, (item: CategoryItem) => {
                      ListItem() {
                        Column() {
                          Image(item.picture)
                            .width(56)
                            .aspectRatio(1)
                          Text(item.name)
                            .fontSize(10)
                            .fontWeight(300)
                            .lineHeight(18)
                            .fontColor($r('[basic].color.black'))
                        }
                        .width(60)
                        .height(80)
                        .borderRadius(30)
                        .backgroundImage(item.picture)
                        .backgroundImageSize(ImageSize.Contain)
                        .backgroundImagePosition(Alignment.Center)
                        .backgroundBlurStyle(
                          BlurStyle.BACKGROUND_ULTRA_THICK,
                          {scale: 0.25}
                        )
                        .clip(true)

                      }
                    })
                  }
                  .padding(16)
                  .width('100%')
                  .height(112)
                  .scrollBar(BarState.Off)
                  .listDirection(Axis.Horizontal)

                  // 特惠推荐
                  Column() {
                    Column({space: 10}) {
                      Image($r('app.media.home_cmd_title'))
                        .width(150)
                        .height(20)

                      Row() {
                        Image($r('app.media.home_cmd_inner'))
                          .width(86)
                          .height(116)
                        List({
                          space: new BreakPointType({
                            // 0 手机
                            // 2 折叠屏
                            // 3 平板
                            sm: 14,
                            md: 36,
                            lg: 72
                          })
                            .getValue(this.breakPoint)
                        })  {
                          ForEach(this.saleGoodsList, (item: GoodsItem) => {
                            ListItem() {
                              Column({space: 10}) {
                                Image(item.picture)
                                  .width(70)
                                  .aspectRatio(1)
                                Text('￥' + item.price)
                                  .fontSize(13)
                                  .fontWeight(700)
                                  .lineHeight(12)
                                  .fontColor('#fff')
                                  .width(64)
                                  .height(20)
                                  .borderRadius(8)
                                  .linearGradient({
                                    angle: 93,
                                    colors: [['#FD3F8F', 0], ['#FF773C', 1]]
                                  })
                                  .textAlign(TextAlign.Center)
                              }
                            }
                          })
                        }
                        .scrollBar(BarState.Off)
                        .layoutWeight(1)
                        .width('100%')
                        .height(116)
                        .backgroundColor('#fff')
                        .borderRadius({
                          topRight: 8,
                          bottomRight: 8
                        })
                        .padding(10)
                        .listDirection(Axis.Horizontal)
                        .width('100%')
                        .height(116)
                      }
                    }
                    .alignItems(HorizontalAlign.Start)
                    .padding(8)
                    .width('100%')
                    .height(166)
                    .backgroundImage($r('app.media.home_cmd_sm'))
                    .backgroundImageSize(ImageSize.Cover)
                    .borderRadius(8)
                  }
                  .padding({left: 8, right: 8})
                  .margin({bottom: 8})


                  // 爆款推荐 和 一站买全
                  Row({space: 8}) {
                    this.discountBuilder({
                      mainTitle: '爆款推荐',
                      subTitle: '最受欢迎',
                      list: this.hotGoodsList,
                      bgc: '#edf1fb'
                    })
                    this.discountBuilder({
                      mainTitle: '一站买全',
                      subTitle: '精心挑选',
                      list: this.oneGoodsList,
                      bgc: '#fcf6ea'
                    })
                  }
                  .width('100%')
                  .padding({left: 8, right: 8})
                  .margin({bottom: 10})

                  // 新鲜好物
                  Column() {
                    Column({space: 8}) {
                      Image($r('app.media.home_new'))
                        .width(146)
                        .height(19)
                      List({space: new BreakPointType({
                        // 0 手机
                        // 2 折叠屏
                        // 3 平板
                        sm: 14,
                        md: 36,
                        lg: 72
                      })
                        .getValue(this.breakPoint)}) {
                        ForEach(this.freshGoodsList, (item: GoodsItem) => {
                          ListItem() {
                            Column({space:10}) {
                              Image(item.picture)
                                .width(60)
                                .aspectRatio(1)
                              Text('￥ ' + item.price)
                                .fontSize(13)
                                .lineHeight(12)
                                .fontWeight(700)
                            }
                            .justifyContent(FlexAlign.Center)
                            .width(76)
                            .height(106)
                            .backgroundColor('#fff')
                            .borderRadius(8)
                          }

                        })
                      }
                      .scrollBar(BarState.Off)
                      .width('100%')
                      .height(106)
                      .layoutWeight(1)
                      .listDirection(Axis.Horizontal)
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width('100%')
                    .height(153)
                    .padding({left: 8, right: 8, top: 10, bottom: 10})
                    .backgroundColor('#f7eff5')
                    .borderRadius(8)
                  }
                  .padding({left: 8, right: 8})
                  .margin({bottom: 10})

                  // 推荐商品
                  WaterFlow() {
                    LazyForEach(this.recomGoodsDataSource, (item: GoodsItem) => {
                      FlowItem() {
                        this.cardGoodsBuilder(item)
                      }
                    })
                  }
                  .columnsTemplate(new BreakPointType({
                    // 0 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: "1fr 1fr",
                    md: "1fr 1fr 1fr",
                    lg: "1fr 1fr 1fr 1fr"
                  })
                    .getValue(this.breakPoint))
                  .columnsGap(8)
                  .rowsGap(8)
                  .padding({
                    left: 8,
                    right: 8,
                    bottom: 10,
                    top: 10
                  })
                  // .onReachEnd( () => {
                  //   promptAction.showToast({message: '刷新'})
                  //   // 如果还有下一页并且没有加载下一页
                  //   // if (this.hasNextPage && !this.isReachLoad) {
                  //   //   this.isReachLoad = true
                  //   //   await this.getRecomData
                  //   //   this.isReachLoad = false
                  //   // }
                  // })

                }
                .width('100%')
                .padding({left: 8, right: 8})
                .backgroundColor('#fff')
              }
              .width('100%')
              .linearGradient({
                angle: 180,
                colors: [['#fff', 0], ['#f5f4f9', 1]]
              })
            }
            .width('100%')
            .height('100%')
            .align(Alignment.Top)
            .scrollBar(BarState.Off)
            .onDidScroll((xOffset: number, yOffset: number, scrollState) => {
              this.yOffset += yOffset
              if (this.yOffset > this.topHeight && this.yOffset < (this.topHeight + 40)) {
                this.searchOpacity = (yOffset - this.topHeight) / 40
              } else if (this.yOffset >= this.topHeight + 40) {
                this.searchOpacity = 1
              } else {
                this.searchOpacity = 0
              }
            })
            .onReachEnd(async () => {
              // 如果还有下一页并且没有加载下一页
              if (this.hasNextPage && !this.isReachLoad) {
                this.isReachLoad = true
                await this.getRecomData()
                this.isReachLoad = false
              }
            })
          }
          .onRefreshing(async () => {
            await this.getHomeData()
            this.page = 1
            await this.getRecomData()
            this.hasNextPage = true
            this.isRefreshing = false
            this.isLoading = false
          })

          // 置顶搜索栏
          SearchBox()
            .padding({top: this.topHeight, bottom: this.topHeight})
            .opacity(this.searchOpacity)
            .linearGradient({
              direction: GradientDirection.Bottom,
              colors: [["#ffdebfee", 0], [$r("[basic].color.white"), 1]]
            })
            .onClick(() => {
              this.pageStack.pushPathByName(PagePath.SEARCH_VIEW, null)
            })

          // 点击置顶小火箭
          Column() {
            Image($r('app.media.home_top'))
              .width(30)
              .aspectRatio(1)
              .fillColor("#0095d3")
          }
          .justifyContent(FlexAlign.Center)
          .visibility(this.searchOpacity == 1 ? Visibility.Visible : Visibility.None)
          .width(50)
          .aspectRatio(1)
          .borderRadius(25)
          .backgroundColor("#fff8f9fa")
          .alignRules({
            right: {
              anchor: '__container__',
              align: HorizontalAlign.End
            },
            bottom: {
              anchor: '__container__',
              align: VerticalAlign.Bottom
            }
          })
          .margin({right: 20, bottom: 20})
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Top)
          })
        }
        .width('100%')
        .height('100%')
      }
    }
    .onReady((data) => {
      // this.pageStack = data.pathStack
      console.log('ready');
    })

  }
}