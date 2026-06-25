import "./Cardchart.css";
export default function Cardchart({title,icon,children}) {
    return (
        <div class="chart-card">
                <div class="chart-header">
                    <h4>{icon} {title}</h4>
                </div>
                <div class="chart-wrapper">
                   { children }
                </div>
            </div>
    );
}