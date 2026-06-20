import "./Sidebar.css";
export default function Sidebar() {
    return (    <div class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-hard-hat"></i>
                </div>
                <div class="logo-text">
                    <h2>ري<span>ن</span>وفا</h2>
                    <p>نظام إعادة الإعمار الذكي</p>
                </div>
            </div>
        </div>
        <div class="sidebar-menu">
            <div class="menu-item active">
                <i class="fas fa-chart-pie"></i>
                <span>لوحة التحكم</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-building"></i>
                <span>المشاريع</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-handshake"></i>
                <span>العروض</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-users"></i>
                <span>المقاولون</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-chart-line"></i>
                <span>التقارير</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-cog"></i>
                <span>الإعدادات</span>
            </div>
        </div>
    </div>)
}