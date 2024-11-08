import { window } from '@kit.ArkUI'
import { GlobalVariable } from '../constants/Index'

export class ScreenManager {
  // 开启全屏
  async full(ctx? :Context) {
    const win = await window.getLastWindow(ctx || getContext())
    win.setWindowLayoutFullScreen(true)
    this.setStatAndNavHeight(ctx)
  }

  // 存储导航栏和状态栏高度
  async setStatAndNavHeight(ctx? :Context) {
    const win = await window.getLastWindow(ctx || getContext())
    // 获取顶部状态栏的高度
    const statHeight = px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
    // 获取底部导航栏的高度
    const navHeight = px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)
    AppStorage.setOrCreate<number>(GlobalVariable.SAFE_AREA_TOP, statHeight)
    AppStorage.setOrCreate<number>(GlobalVariable.SAFE_AREA_BOTTOM, navHeight)
  }

  // 关闭全屏
  async exitFull(ctx? :Context) {
    const win = await window.getLastWindow(ctx || getContext())
    win.setWindowLayoutFullScreen(false)
  }
}

export const screenManager = new ScreenManager()