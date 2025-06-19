// 课程项目模型
interface GeneratedTypeLiteralInterface_1 {
  id?: string;
  name?: string;
  teacher?: string;
  classroom?: string;
  weekDay?: number;
  timeSlot?: number;
  duration?: number;
  weekStart?: number;
  weekEnd?: number;
  color?: string;
}

export class CourseItem {
  id: string;
  name: string;
  teacher: string;
  classroom: string;
  weekDay: number; // 1-7 表示周一到周日
  timeSlot: number; // 第几节课
  duration: number; // 持续节数
  weekStart: number; // 开始周次
  weekEnd: number; // 结束周次
  color: string;
  
  constructor(init?: GeneratedTypeLiteralInterface_1) {
    this.id = init?.id || '';
    this.name = init?.name || '';
    this.teacher = init?.teacher || '';
    this.classroom = init?.classroom || '';
    this.weekDay = init?.weekDay || 1;
    this.timeSlot = init?.timeSlot || 1;
    this.duration = init?.duration || 1;
    this.weekStart = init?.weekStart || 1;
    this.weekEnd = init?.weekEnd || 18;
    this.color = init?.color || '#2196F3';
  }

  // 判断课程是否在指定周次
  isInWeek(week: number): boolean {
    return week >= this.weekStart && week <= this.weekEnd;
  }
}

// 用户配置模型
interface GeneratedTypeLiteralInterface_2 {
  enableNotification?: boolean;
  advanceMinutes?: number;
}

export class UserConfig {
  enableNotification: boolean;
  advanceMinutes: number;
  
  constructor(init?: GeneratedTypeLiteralInterface_2) {
    this.enableNotification = init?.enableNotification || true;
    this.advanceMinutes = init?.advanceMinutes || 15;
  }
}

// 时间段接口
export interface TimeSlot {
  label: string;
  startTime: string;
  endTime: string;
}

// 星期日期接口
export interface WeekDay {
  day: string;
  date: string;
}
