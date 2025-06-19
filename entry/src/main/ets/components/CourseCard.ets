import { CourseItem } from '../models/CourseModel';

@Component
export default struct CourseCard {
  @Prop course: CourseItem;
  @State isPressed: boolean = false;
  
  build() {
    Column() {
      Text(this.course.name)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      
      Text(this.course.classroom)
        .fontSize(12)
        .margin({ top: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      
      Text(this.course.teacher)
        .fontSize(12)
        .margin({ top: 2 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isPressed ? this.lightenColor(this.course.color) : this.course.color)
    .borderRadius(8)
    .padding(4)
    .alignItems(HorizontalAlign.Start)
    .gesture(
      LongPressGesture()
        .onAction(() => {
          this.isPressed = true;
          setTimeout(() => {
            this.isPressed = false;
          }, 100);
        })
    )
  }
  
  // 使颜色变亮的辅助函数
  private lightenColor(color: string): string {
    if (color.startsWith('#')) {
      const hex = color.slice(1);
      const r = parseInt(hex.slice(0, 2), 16);
      const g = parseInt(hex.slice(2, 4), 16);
      const b = parseInt(hex.slice(4, 6), 16);
      
      // 使颜色变浅
      const lightenFactor = 0.2;
      const newR = Math.min(255, Math.round(r + (255 - r) * lightenFactor));
      const newG = Math.min(255, Math.round(g + (255 - g) * lightenFactor));
      const newB = Math.min(255, Math.round(b + (255 - b) * lightenFactor));
      
      return `#${this.toHex(newR)}${this.toHex(newG)}${this.toHex(newB)}`;
    }
    return color;
  }
  
  private toHex(value: number): string {
    const hex = value.toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  }
}
