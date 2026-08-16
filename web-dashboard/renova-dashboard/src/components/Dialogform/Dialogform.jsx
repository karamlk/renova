import "./Dialogform.css";
//Hooks
import { useTranslation } from 'react-i18next';
export default function Dialogform({h,w,title,children,b1="",b2="",icon,closebtn="",borderclr="#f07c1f"}) {
    const {t}=useTranslation();
    return(
        <div className="dialog-overlay">
        <div className="dialog-box" style={{height:h,width:w,borderTop:`5px solid ${borderclr}`}}>
            <div className="dialog-header" >
                <h3>{icon}{t(title)}</h3>
                <div>{closebtn}</div>
            </div>
            <div className="dialog-body">
                {children}
            </div>
            <div className="dialog-footer">
               {b1}
               {b2}
            </div>

        </div>
    </div>
    )
}