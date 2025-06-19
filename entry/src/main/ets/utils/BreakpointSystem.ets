import { hilog } from '@kit.PerformanceAnalysisKit';
import mediaQuery from '@ohos.mediaquery';

const DOMAIN = 0x0000;
const TAG = 'BreakpointSystem';

// 屏幕尺寸定义
export enum BreakpointConstants {
  BREAKPOINT_SM = 320,  // 小屏幕断点值
  BREAKPOINT_MD = 600,  // 中屏幕断点值
  BREAKPOINT_LG = 840   // 大屏幕断点值
}

// 设备类型枚举
export enum DeviceType {
  PHONE = 0,
  TABLET,
  DESKTOP
}

// 创建屏幕断点系统类
export class BreakpointSystem {
  private smListener: mediaQuery.MediaQueryListener;
  private mdListener: mediaQuery.MediaQueryListener;
  private lgListener: mediaQuery.MediaQueryListener;
  
  // 当前设备类型
  public currentDeviceType: DeviceType = DeviceType.PHONE;
  
  constructor() {
    // 监听小屏幕
    this.smListener = mediaQuery.matchMediaSync(`(min-width: ${BreakpointConstants.BREAKPOINT_SM}px)`);
    
    // 监听中屏幕
    this.mdListener = mediaQuery.matchMediaSync(`(min-width: ${BreakpointConstants.BREAKPOINT_MD}px)`);
    
    // 监听大屏幕
    this.lgListener = mediaQuery.matchMediaSync(`(min-width: ${BreakpointConstants.BREAKPOINT_LG}px)`);
  }
  
  // 注册屏幕变化回调
  public register(callback: (deviceType: DeviceType) => void): void {
    this.smListener.on('change', (mediaQueryResult) => {
      if (mediaQueryResult.matches) {
        hilog.info(DOMAIN, TAG, 'Small screen matched');
      }
    });
    
    this.mdListener.on('change', (mediaQueryResult) => {
      if (mediaQueryResult.matches) {
        hilog.info(DOMAIN, TAG, 'Medium screen matched');
        this.currentDeviceType = DeviceType.TABLET;
        callback(DeviceType.TABLET);
      } else {
        this.currentDeviceType = DeviceType.PHONE;
        callback(DeviceType.PHONE);
      }
    });
    
    this.lgListener.on('change', (mediaQueryResult) => {
      if (mediaQueryResult.matches) {
        hilog.info(DOMAIN, TAG, 'Large screen matched');
        this.currentDeviceType = DeviceType.DESKTOP;
        callback(DeviceType.DESKTOP);
      }
    });
  }
  
  // 取消注册所有监听
  public unregister(): void {
    this.smListener.off('change');
    this.mdListener.off('change');
    this.lgListener.off('change');
  }
  
  // 根据设备类型获取不同布局参数
  public getLayoutParam<T>(phone: T, tablet: T, desktop: T): T {
    switch (this.currentDeviceType) {
      case DeviceType.PHONE:
        return phone;
      case DeviceType.TABLET:
        return tablet;
      case DeviceType.DESKTOP:
        return desktop;
      default:
        return phone;
    }
  }
}
