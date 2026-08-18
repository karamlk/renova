import "./Footer.css";
//Hooks
import { useTranslation } from 'react-i18next';

export default function Footer() {
    const [t]=useTranslation();
    return (       
         <div className="footer">
            <div className="footer-copyright">
                <img src="/assets/images/logo1.png" alt="Logo" width="23" height="23" />
                <span>© 2026 {t("نظام إعادة الإعمار - جميع الحقوق محفوظة")}</span>
            </div>
            <div className="footer-links">
                <a href="#">{t("الشروط والأحكام")}</a>
                <a href="#">{t("سياسة الخصوصية")}</a>
                <a href="#">{t("اتصل بنا")}</a>
            </div>
        </div>
    )
}