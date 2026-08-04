import "./Card.css"
//MUI Icons
import FolderIcon from '@mui/icons-material/Folder';
export default function Card({number, title, iconright}) {
    return (
        <div>
            <div className="stat-card">
                <div className="stat-middle">
                    <span>{number}</span>
                    <div className="stat">{iconright}</div>
                </div>
                <br/>
                <div className="stat-right">
                    <FolderIcon sx={{ color: "#f07c1f" }} fontSize="small"/>
                    <p>{title}</p>
                </div>
            </div>
        </div>
    )
}