import "./Confirmdialog.css";
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Button from '../Button/Button';
export default function Confirmdialog({icon,title , message ,name_btn1,btnColor,name_btn2 , onClose , onConfirm }) {
    const [t] = useTranslation();
    return(
        <div className="dialog-overlay" onClick={onClose}>
        <div className="dialog">
            {icon}
            <h3>{title} </h3>
            <p>
                {message}
                <br />
                {t("لا يمكن التراجع عن هذا الإجراء")}
            </p>
            <div className="btn-group">
                <Button  className="conf-cancel" text={name_btn1} onClick={onClose}/>
                <Button  className="conf-accept" onClick={onConfirm} text={name_btn2} bgc={btnColor}/>
            </div>
        </div>
    </div>
    )
}