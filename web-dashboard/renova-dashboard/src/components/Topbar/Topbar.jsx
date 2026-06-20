import "./Topbar.css";
export default function Topbar() {
    return (
    <div class="top-bar">
            <div class="page-title">
                <h1>مرحباً، <span>أحمد المنصور</span></h1>
                <p>نظرة عامة على أداء نظام إعادة الإعمار</p>
            </div>
            <div class="user-section">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="بحث عن مشروع..."/>
                </div>
                <div class="notification">
                    <i class="fas fa-bell"></i>
                    <div class="notification-badge">3</div>
                </div>
                <div class="user-card">
                    <div class="avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <span>أحمد المنصور</span>
                </div>
            </div>
        </div>
        );
    
}