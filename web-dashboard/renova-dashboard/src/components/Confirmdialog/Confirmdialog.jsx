import "./Confirmdialog.css";
//MUI Icons

//Hooks
import { useTranslation } from 'react-i18next';
export default function Confirmdialog({icon,title , message ,name_btn1,name_btn2 , onClose , onConfirm }) {
    const [t] = useTranslation();
    return(
        <div className="delete-overlay" onClick={onClose}>
        <div className="delete-dialog">
            {icon}
            <h3>{title} </h3>
            <p>
                {message}
                <br />
                {t("لا يمكن التراجع عن هذا الإجراء")}
            </p>
            <div className="btn-group">
                <button className="btn-cancel" onClick={onClose} >{name_btn1}</button>
                <button className="btn-delete" onClick={onConfirm} >{name_btn2}</button>
            </div>
        </div>
    </div>
    )
}