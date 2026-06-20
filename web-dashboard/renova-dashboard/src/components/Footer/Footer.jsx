import "./Footer.css";
export default function Footer() {
    return (       
         <div className="footer">
            <div className="footer-copyright">
                <img src="/assets/images/logo1.png" alt="Logo" width="23" height="23" />
                <span>© 2024 نظام إعادة الإعمار - جميع الحقوق محفوظة</span>
            </div>
            <div className="footer-links">
                <a href="#">الشروط والأحكام</a>
                <a href="#">سياسة الخصوصية</a>
                <a href="#">اتصل بنا</a>
            </div>
        </div>
    )
}