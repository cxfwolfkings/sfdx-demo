import { LightningElement, track } from 'lwc';
// 引用共享库
import { getTermOptions, calculateMonthlyPayment } from 'c/commonHelper';

/**
 * 属性：
 * @track：private、reactive
 * @api：public、reactive
 * 
 * 根据条件渲染组件：
 * 指令 - `if:true|false={property}`
 * 
 * 列表渲染：
 * 指令 - `for:each` 或 `iterator`
 * 遍历的每一项都要加key属性（唯一标识），作用是：当源数组中的数据变化时，只需要重新渲染变更项对应的DOM。
 * `for:item="currentItem"` 使用currentItem访问每个item
 * `for:index="index"` 获取每项索引
 * 如果要特殊处理首尾项，使用iterator指令更便捷！
 * `iterator:iteratorName={array}`
 * 使用iteratorName访问下面属性：
 *   - value - 列表中元素
 *   - index - 元素索引
 *   - first - 是否第一项，布尔值
 *   - last - 是否最后一项，布尔值
 */
export default class LwcDemo01 extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track areDetailsVisible = false;

    // 私有属性，无法交互，不能渲染
    email = '';

    @track principal = 200000;
    @track term = 30;
    @track rate = 4;
    @track monthlyPayment = '';

    handleChange(event) {
        this.areDetailsVisible = event.target.checked;
    }

    handleChangeFullName(event) {
        const field = event.target.name;
        if (field === "firstName") {
            this.firstName = event.target.value;
        } else if (field === "lastName"){
            this.lastName = event.target.value;
        }
    }

    /**
     * 使用getter比直接使用表达式更好！
     * 支持单元测试
     */
    get uppercasedFullName() {
        return `${this.firstName} ${this.lastName}`.toUpperCase();
    }

    get computedValue() {
        return false;
    }

    get contacts() {
        return [
            {
                Id: 1,
                Name: 'Amy Taylor',
                Title: 'VP of Engineering',
            },
            {
                Id: 2,
                Name: 'Michael Jones',
                Title: 'VP of Sales',
            },
            {
                Id: 3,
                Name: 'Jennifer Wu',
                Title: 'CEO',
            },
        ];
    }

    // 调用共享代码
    termOptions = getTermOptions();

    principalChange(event) {
        this.principal = event.target.value;
    }

    termChange(event) {
        this.term = parseInt(event.target.value, 10);
    }

    rateChange(event) {
        this.rate = event.target.value;
    }

    calculateMonthlyPayment() {
        this.monthlyPayment = calculateMonthlyPayment(
            this.principal,
            this.term,
            this.rate
        );
    }
}