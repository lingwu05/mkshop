import { BreakPointEnum, BreakPointType, HttpRequest } from "basic"
import { SearchBox } from "basic/src/main/ets/components/Index"
import { GlobalVariable } from "basic/src/main/ets/constants/GlobalVariable"
import { HomeHttpApi } from "../../api/Index"
import { BannerItem, CategoryItem, DiscountBuilderParam, GoodsItem } from "../../models/Index"

@Component
export struct HomeView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP) topHeight: number = 0
  @StorageProp(GlobalVariable.BREAK_POINT_KEY) breakPoint: string = ''
  @State bannerList: BannerItem[] = []
  @State categoryList: CategoryItem[] = []
  @State saleGoodsList: GoodsItem[] = []
  @State hitGoodsList: GoodsItem[] = [] // 爆款推荐下的商品列表
  @State oneGoodsList: GoodsItem[] = [] // 一站买全下的商品列表
  @State freshGoodsList: GoodsItem[] = [] // 新鲜好物商品列表
  @State recomGoodsList: GoodsItem[] = [] // 推荐商品列表

  aboutToAppear(): void {
    this.mockData()
  }

  // 模拟数据
  mockData() {
    this.bannerList = new Array(6).fill({
      img: 'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/banner/nuandong_sj.png'
    } as BannerItem)
    // this.categoryList = new Array(8).fill({
    //   img: 'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png',
    //   name: '气质女装',
    //   bgc: '#f9f6f0'
    // } as CategoryItem)
    this.saleGoodsList = new Array(10).fill({
      "name": "剪出精致感，金致圆柄复古剪刀",
      "desc": "轻薄设计，简约大方",
      "price": "9.90",
      "img": "https://yanxuan-item.nosdn.127.net/4c6a9c8a579b00e5e9c7b002d15a33a2.jpg",
    })
    this.hitGoodsList = new Array(10).fill({
      "name": "手工八年老陈醋500毫升",
      "desc": "地道醇香，醋酸浓郁",
      "price": "30.00",
      "img": "https://yanxuan-item.nosdn.127.net/77da20e77b02830a26f931901ac1a9e0.png",
    })
    this.oneGoodsList = new Array(10).fill({
      "name": "免浸泡，12种谷物一次同享，五谷米400克",
      "desc": "无需浸泡，同煮同熟",
      "price": "9.90",
      "img": "https://yanxuan-item.nosdn.127.net/bfe70bd66efe94f2f18061c707d2a097.png",
    })
    this.freshGoodsList = new Array(10).fill({
      "name": "亮碟多效合一洗涤块495g",
      "desc": "洗碗机专用，强力去污",
      "price": "69.90",
      "img": "https://yanxuan-item.nosdn.127.net/e07c2b63765cf9f4a46d489c6e09c1c1.jpg",
    })
    this.recomGoodsList = new Array(20).fill({
      "name": "3秒快速拆琴轻松保养odin奥丁12半音阶口琴",
      "price": 329,
      "img": "https://yanxuan-item.nosdn.127.net/937a8e46a9284e8f7e00e13911ecfbe7.png",
    })
  }

  // 获取真实的数据
  async getRealData() {
    this.bannerList = await HomeHttpApi.getBannerData()
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
    RelativeContainer() {
      Scroll() {
        Column() {
          // 轮播图
          Swiper() {
            ForEach(this.bannerList, (item: BannerItem) => {
              Image(item.img)
            })
          }
          .autoPlay(true)
          .indicator(DotIndicator.dot()
            .itemWidth(8)
            .itemHeight(4)
            .color('#33191919')
            .selectedItemWidth(24)
            .selectedItemHeight(4)
            .selectedColor('#191919'))
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
                list: this.hitGoodsList,
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
              ForEach(this.recomGoodsList, (item: GoodsItem) => {
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

      // 置顶搜索栏
      SearchBox()
        .padding({top: this.topHeight})
    }
    .width('100%')
    .height('100%')
  }
}